# Trendy - Database Schema Design Overview

## Overview
This document outlines the database schema extensions required to support all 174 features requested for Trendy. The design extends the existing models and introduces new ones to support the full feature set.

## Existing Models (Current Structure)

### User
- id (Integer, Primary Key)
- email (String, Unique)
- username (String, Unique)
- password (String)
- profile_image (String, Nullable)
- avatar_url (String, Nullable)
- created_at (DateTime)
- Relationships:
  - posts (Post)
  - comments (Comment)
  - followers (Follower)
  - following (Follower)

### Post
- id (Integer, Primary Key)
- user_id (ForeignKey to User)
- content (String)
- image_url (String, Nullable)
- created_at (DateTime)
- category (String, Default: "general")
- type (String, Default: "post")
- likes_count (Integer, Default: 0)
- views_count (Integer, Default: 0)
- Relationships:
  - user (User)
  - comments (Comment)

### Comment
- id (Integer, Primary Key)
- text (String)
- post_id (ForeignKey to Post)
- owner_id (ForeignKey to User)
- created_at (DateTime)
- Relationships:
  - post (Post)
  - owner (User)

### Follower
- id (Integer, Primary Key)
- follower_id (ForeignKey to User)
- followed_id (ForeignKey to User)
- created_at (DateTime)
- Relationships:
  - follower (User)
  - followed (User)