import stripe
import os
from typing import Dict, Optional, List
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from app.models.user import User
from app.models.subscription_corrected import Subscription, Payment
from app.core.config import get_settings

class StripeService:
    def __init__(self):
        # Initialize Stripe with API key from environment
        settings = get_settings()
        stripe.api_key = os.getenv("STRIPE_SECRET_KEY") or settings.stripe_secret_key
        if not stripe.api_key:
            raise ValueError("STRIPE_SECRET_KEY environment variable is required")
    
    async def create_customer(self, user: User, email: str) -> str:
        """Create a Stripe customer for a user"""
        try:
            customer = stripe.Customer.create(
                email=email,
                metadata={
                    "user_id": str(user.id),
                    "username": user.username
                }
            )
            return customer.id
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to create customer: {str(e)}"
            )
    
    async def create_checkout_session(
        self, 
        user: User, 
        price_id: str, 
        success_url: str, 
        cancel_url: str
    ) -> Dict:
        """Create a Stripe checkout session for subscription"""
        try:
            # Get or create customer
            customer_id = await self.get_or_create_customer(user)
            
            session = stripe.checkout.Session.create(
                customer=customer_id,
                payment_method_types=['card'],
                line_items=[{
                    'price': price_id,
                    'quantity': 1,
                }],
                mode='subscription',
                success_url=success_url,
                cancel_url=cancel_url,
                metadata={
                    "user_id": str(user.id),
                    "username": user.username
                }
            )
            
            return {
                "session_id": session.id,
                "url": session.url
            }
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to create checkout session: {str(e)}"
            )
    
    async def get_or_create_customer(self, user: User) -> str:
        """Get existing customer or create a new one"""
        try:
            # Check if user already has a Stripe customer ID
            if user.subscriptions:
                for subscription in user.subscriptions:
                    if subscription.stripe_customer_id:
                        return subscription.stripe_customer_id
            
            # Create new customer
            customer_id = await self.create_customer(user, user.email)
            return customer_id
            
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to get or create customer: {str(e)}"
            )
    
    async def create_payment_intent(
        self, 
        user: User, 
        amount: int, 
        currency: str = "usd",
        description: str = None
    ) -> Dict:
        """Create a payment intent for one-time payments"""
        try:
            customer_id = await self.get_or_create_customer(user)
            
            intent = stripe.PaymentIntent.create(
                amount=amount,
                currency=currency,
                customer=customer_id,
                description=description,
                metadata={
                    "user_id": str(user.id),
                    "username": user.username
                }
            )
            
            return {
                "client_secret": intent.client_secret,
                "payment_intent_id": intent.id,
                "amount": intent.amount,
                "currency": intent.currency
            }
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to create payment intent: {str(e)}"
            )
    
    async def handle_webhook_event(self, payload: bytes, sig_header: str) -> Dict:
        """Handle Stripe webhook events"""
        try:
            # Verify webhook signature
            event = stripe.Webhook.construct_event(
                payload, sig_header, os.getenv("STRIPE_WEBHOOK_SECRET")
            )
            
            # Handle different event types
            if event['type'] == 'checkout.session.completed':
                await self._handle_checkout_completed(event)
            elif event['type'] == 'customer.subscription.updated':
                await self._handle_subscription_updated(event)
            elif event['type'] == 'customer.subscription.deleted':
                await self._handle_subscription_deleted(event)
            elif event['type'] == 'payment_intent.succeeded':
                await self._handle_payment_succeeded(event)
            
            return {"status": "success", "event": event['type']}
            
        except stripe.error.SignatureVerificationError:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid webhook signature"
            )
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Webhook error: {str(e)}"
            )
    
    async def _handle_checkout_completed(self, event: Dict):
        """Handle checkout session completed event"""
        session = event['data']['object']
        user_id = session['metadata'].get('user_id')
        subscription_id = session.get('subscription')
        
        # TODO: Update user subscription in database
        # This would be implemented with database session
        
    async def _handle_subscription_updated(self, event: Dict):
        """Handle subscription updated event"""
        subscription = event['data']['object']
        # TODO: Update subscription status in database
        
    async def _handle_subscription_deleted(self, event: Dict):
        """Handle subscription deleted event"""
        subscription = event['data']['object']
        # TODO: Mark subscription as canceled in database
        
    async def _handle_payment_succeeded(self, event: Dict):
        """Handle payment succeeded event"""
        payment_intent = event['data']['object']
        # TODO: Record successful payment in database
    
    async def get_subscription_plans(self) -> List[Dict]:
        """Get available subscription plans"""
        try:
            prices = stripe.Price.list(active=True, type='recurring')
            plans = []
            
            for price in prices.data:
                product = stripe.Product.retrieve(price.product)
                plans.append({
                    "id": price.id,
                    "product_id": product.id,
                    "name": product.name,
                    "description": product.description,
                    "amount": price.unit_amount,
                    "currency": price.currency,
                    "interval": price.recurring.interval,
                    "interval_count": price.recurring.interval_count,
                    "metadata": product.metadata
                })
            
            return plans
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to get subscription plans: {str(e)}"
            )

# Create global instance
stripe_service = StripeService()
