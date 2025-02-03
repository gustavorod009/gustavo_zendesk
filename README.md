# gustavo_zendesk
Zendesk QA - Gustavo

# Customer Service Review System Data Model

This repository contains the data model for a customer service review system. The data model is designed to store and manage information about conversations, payments, external tickets, reviews (both manual and automated), review ratings, root causes, teams, reviewers, reviewees, comments, and scorecards.

## Table of Contents
- [Schema Overview](#schema-overview)
- [Tables and Attributes](#tables-and-attributes)
  - [Conversations](#conversations)
  - [Payments](#payments)
  - [External Tickets](#external-tickets)
  - [Reviews](#reviews)
  - [Review Ratings](#review-ratings)
  - [Rating Root Causes](#rating-root-causes)
  - [Teams](#teams)
  - [Reviewers](#reviewers)
  - [Reviewees](#reviewees)
  - [Comments](#comments)
  - [Scorecards](#scorecards)
- [Relationships](#relationships)
- [How to Use](#how-to-use)
- [Looker Model: LookML File](#looker-model-lookml-file)  
- [Airflow DAG](#airflow-dag)  
- [SQL Tasks (Part A)](#sql-tasks-part-a)  

## Schema Overview

The data model consists of the following tables:
- `conversations`
- `payments`
- `external_tickets`
- `reviews`
- `review_ratings`
- `rating_root_causes`
- `teams`
- `reviewers`
- `reviewees`
- `comments`
- `scorecards`

## Tables and Attributes

### Conversations
Stores information about customer service conversations.

| Attribute                        | DataType   | Description                                        |
|----------------------------------|------------|----------------------------------------------------|
| conversation_id                  | INT64      | Primary key, unique identifier for the conversation|
| conversation_created_at          | TIMESTAMP  | Timestamp when the conversation was created        |
| conversation_created_at_date     | DATE       | Date when the conversation was created             |
| channel                          | STRING     | Communication channel used for the conversation    |
| assignee_id                      | INT64      | Foreign key referencing `teams.assignee_id`        |
| updated_at                       | TIMESTAMP  | Timestamp when the conversation was last updated   |
| closed_at                        | TIMESTAMP  | Timestamp when the conversation was closed         |
| message_count                    | INT64      | Number of messages in the conversation             |
| last_reply_at                    | TIMESTAMP  | Timestamp of the last reply in the conversation    |
| language                         | STRING     | Language of the conversation                       |
| imported_at                      | TIMESTAMP  | Timestamp when the conversation data was imported  |
| unique_public_agent_count        | INT64      | Count of unique public agents                      |
| public_mean_character_count      | FLOAT64    | Mean character count of public messages            |
| public_mean_word_count           | FLOAT64    | Mean word count of public messages                 |
| private_message_count            | INT64      | Number of private messages                         |
| public_message_count             | INT64      | Number of public messages                          |
| klaus_sentiment                  | STRING     | Sentiment analysis result                          |
| is_closed                        | BOOL       | Boolean indicating if the conversation is closed   |
| agent_most_public_messages       | INT64      | ID of the agent with the most public messages      |
| first_response_time              | INT64      | Time to first response in seconds                  |
| first_resolution_time_seconds    | INT64      | Time to first resolution in seconds                |
| full_resolution_time_seconds     | INT64      | Time to full resolution in seconds                 |
| most_active_internal_user_id     | INT64      | ID of the most active internal user                |
| deleted_at                       | STRING     | Timestamp when the conversation was deleted        |
| payment_id                       | INT64      | Foreign key referencing `payments.payment_id`      |
| external_ticket_id               | INT64      | Foreign key referencing `external_tickets.external_ticket_id` |

### Payments
Stores information about payments related to conversations.

| Attribute       | DataType | Description                                      |
|-----------------|----------|--------------------------------------------------|
| payment_id      | INT64    | Primary key, unique identifier for the payment   |
| payment_token_id| INT64    | Token identifier for the payment                 |
| payment_amount  | FLOAT64  | Amount of the payment                            |
| payment_date    | DATE     | Date of the payment                              |
| payment_status  | STRING   | Status of the payment                            |

### External Tickets
Stores information about external tickets linked to conversations.

| Attribute               | DataType  | Description                                  |
|-------------------------|-----------|----------------------------------------------|
| external_ticket_id      | INT64     | Primary key, unique identifier for the ticket|
| conversation_external_id| INT64     | External identifier for the conversation     |
| ticket_status           | STRING    | Status of the ticket                         |
| ticket_priority         | STRING    | Priority of the ticket                       |
| ticket_created_at       | TIMESTAMP | Timestamp when the ticket was created        |

### Reviews
Stores information about reviews of conversations, including both manual and automated reviews.

| Attribute               | DataType   | Description                                       |
|-------------------------|------------|---------------------------------------------------|
| review_id               | INT64      | Primary key for manual reviews                    |
| autoqa_review_id        | STRING     | Primary key for automated reviews                 |
| created_at              | TIMESTAMP  | Timestamp when the review was created             |
| conversation_created_at | TIMESTAMP  | Foreign key referencing `conversations.conversation_created_at` |
| conversation_created_date| DATE       | Foreign key referencing `conversations.conversation_created_at_date` |
| updated_at              | TIMESTAMP  | Timestamp when the review was last updated        |
| assignment_review       | BOOL       | Boolean indicating if the review was assigned     |
| seen                    | BOOL       | Boolean indicating if the review was seen         |
| disputed                | BOOL       | Boolean indicating if the review was disputed     |
| review_time_seconds     | STRING     | Time taken for the review in seconds              |
| assignment_name         | STRING     | Name of the assignment                            |
| imported_at             | TIMESTAMP  | Timestamp when the review data was imported       |
| team_id                 | INT64      | Foreign key referencing `teams.team_id`           |
| reviewer_id             | INT64      | Foreign key referencing `reviewers.reviewer_id`   |
| reviewee_internal_id    | INT64      | Foreign key referencing `reviewees.reviewee_internal_id` |
| reviewee_id             | INT64      | Foreign key referencing `reviewees.reviewee_id`   |
| comment_id              | INT64      | Foreign key referencing `comments.comment_id`     |
| scorecard_id            | INT64      | Foreign key referencing `scorecards.scorecard_id` |
| scorecard_tag           | STRING     | Tag of the scorecard                              |
| score                   | FLOAT64    | Score given in the review                         |
| updated_by              | INT64      | ID of the user who last updated the review        |
| PRIMARY KEY             | (review_id, autoqa_review_id) |

### Review Ratings
Stores information about the ratings given in reviews.

| Attribute      | DataType  | Description                              |
|----------------|-----------|------------------------------------------|
| rating_id      | INT64     | Primary key, unique identifier for the rating |
| review_id      | INT64     | Foreign key referencing `reviews.review_id`    |
| category_id    | INT64     | Identifier for the rating category        |
| rating         | INT64     | Rating score                              |
| rating_max     | INT64     | Maximum possible rating                   |
| weight         | FLOAT64   | Weight of the rating                      |
| critical       | BOOL      | Boolean indicating if the category is critical |
| category_name  | STRING    | Name of the rating category               |

### Rating Root Causes
Stores information about the root causes of ratings.

| Attribute   | DataType  | Description                            |
|-------------|-----------|----------------------------------------|
| root_cause_id | INT64   | Primary key, unique identifier for the root cause |
| rating_id   | INT64     | Foreign key referencing `review_ratings.rating_id` |
| category    | STRING    | Category of the root cause             |
| count       | INT64     | Count of occurrences                    |
| root_cause  | STRING    | Description of the root cause          |

### Teams
Stores information about teams involved in conversations and reviews.

| Attribute    | DataType | Description                                     |
|--------------|----------|-------------------------------------------------|
| team_id      | INT64    | Primary key, unique identifier for the team     |
| team_name    | STRING   | Name of the team                                |
| assignee_id  | INT64    | Foreign key referencing `users.user_id`         |
| team_lead_id | INT64    | Foreign key referencing `users.user_id`         |

### Reviewers
Stores information about reviewers who conduct manual reviews.

| Attribute      | DataType | Description                                  |
|----------------|----------|----------------------------------------------|
| reviewer_id    | INT64    | Primary key, unique identifier for the reviewer |
| reviewer_name  | STRING   | Name of the reviewer                         |
| reviewer_email | STRING   | Email of the reviewer                        |
| reviewer_role  | STRING   | Role of the reviewer                         |

### Reviewees
Stores information about reviewees who are reviewed in both manual and automated reviews.

| Attribute            | DataType | Description                                      |
|----------------------|----------|--------------------------------------------------|
| reviewee_internal_id | INT64    | Primary key for internal ID                      |
| reviewee_id          | INT64    | Primary key for external ID                      |
| reviewee_name        | STRING   | Name of the reviewee                             |
| reviewee_email       | STRING   | Email of the reviewee                            |
| reviewee_role        | STRING   | Role of the reviewee                             |
| PRIMARY KEY          | (reviewee_internal_id, reviewee_id)                         |

### Comments
Stores information about comments made on reviews.

| Attribute         | DataType  | Description                            |
|-------------------|-----------|----------------------------------------|
| comment_id        | INT64     | Primary key, unique identifier for the comment |
| comment_text      | STRING    | Text of the comment                    |
| comment_author_id | INT64     | Foreign key referencing `users.user_id`|
| comment_created_at| TIMESTAMP | Timestamp when the comment was created |

### Scorecards
Stores information about scorecards used in reviews.

| Attribute               | DataType  | Description                                      |
|-------------------------|-----------|--------------------------------------------------|
| scorecard_id            | INT64     | Primary key, unique identifier for the scorecard |
| scorecard_tag           | STRING    | Tag associated with the scorecard                |
| score                   | FLOAT64   | Score associated with the scorecard              |
| scorecard_name          | STRING    | Name of the scorecard                            |
| scorecard_description   | STRING    | Description of the scorecard                     |

## Relationships

- `conversations.assignee_id` references `teams.assignee_id`
- `conversations.payment_id` references `payments.payment_id`
- `conversations.external_ticket_id` references `external_tickets.external_ticket_id`
- `reviews.conversation_created_at` references `conversations.conversation_created_at`
- `reviews.conversation_created_date` references `conversations.conversation_created_at_date`
- `reviews.team_id` references `teams.team_id`
- `reviews.reviewer_id` references `reviewers.reviewer_id`
- `reviews.reviewee_internal_id` references `reviewees.reviewee_internal_id`
- `reviews.reviewee_id` references `reviewees.reviewee_id`
- `reviews.comment_id` references `comments.comment_id`
- `reviews.scorecard_id` references `scorecards.scorecard_id`
- `review_ratings.review_id` references `reviews.review_id`
- `rating_root_causes.rating_id` references `review_ratings.rating_id`

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine using:
   ```sh
   git clone https://github.com/gustavorod009/gustavo_zendesk
