CREATE TABLE "conversations" (
  "conversation_id" INT64 PRIMARY KEY,
  "conversation_created_at" TIMESTAMP,
  "conversation_created_at_date" DATE,
  "channel" STRING,
  "assignee_id" INT64,
  "updated_at" TIMESTAMP,
  "closed_at" TIMESTAMP,
  "message_count" INT64,
  "last_reply_at" TIMESTAMP,
  "language" STRING,
  "imported_at" TIMESTAMP,
  "unique_public_agent_count" INT64,
  "public_mean_character_count" FLOAT64,
  "public_mean_word_count" FLOAT64,
  "private_message_count" INT64,
  "public_message_count" INT64,
  "klaus_sentiment" STRING,
  "is_closed" BOOL,
  "agent_most_public_messages" INT64,
  "first_response_time" INT64,
  "first_resolution_time_seconds" INT64,
  "full_resolution_time_seconds" INT64,
  "most_active_internal_user_id" INT64,
  "deleted_at" STRING,
  "payment_id" INT64,
  "external_ticket_id" INT64
);

CREATE TABLE "payments" (
  "payment_id" INT64 PRIMARY KEY,
  "payment_token_id" INT64,
  "payment_amount" FLOAT64,
  "payment_date" DATE,
  "payment_status" STRING
);

CREATE TABLE "external_tickets" (
  "external_ticket_id" INT64 PRIMARY KEY,
  "conversation_external_id" INT64,
  "ticket_status" STRING,
  "ticket_priority" STRING,
  "ticket_created_at" TIMESTAMP
);

CREATE TABLE "reviews" (
  "review_id" INT64,
  "autoqa_review_id" STRING,
  "created_at" TIMESTAMP,
  "conversation_created_at" TIMESTAMP,
  "conversation_created_date" DATE,
  "updated_at" TIMESTAMP,
  "assignment_review" BOOL,
  "seen" BOOL,
  "disputed" BOOL,
  "review_time_seconds" STRING,
  "assignment_name" STRING,
  "imported_at" TIMESTAMP,
  "team_id" INT64,
  "reviewer_id" INT64,
  "reviewee_internal_id" INT64,
  "reviewee_id" INT64,
  "comment_id" INT64,
  "scorecard_id" INT64,
  "scorecard_tag" STRING,
  "score" FLOAT64,
  "updated_by" INT64,
  PRIMARY KEY ("review_id", "autoqa_review_id")
);

CREATE TABLE "review_ratings" (
  "rating_id" INT64 PRIMARY KEY,
  "review_id" INT64,
  "category_id" INT64,
  "rating" INT64,
  "rating_max" INT64,
  "weight" FLOAT64,
  "critical" BOOL,
  "category_name" STRING
);

CREATE TABLE "rating_root_causes" (
  "root_cause_id" INT64 PRIMARY KEY,
  "rating_id" INT64,
  "category" STRING,
  "count" INT64,
  "root_cause" STRING
);

CREATE TABLE "teams" (
  "team_id" INT64 PRIMARY KEY,
  "team_name" STRING,
  "assignee_id" INT64,
  "team_lead_id" INT64
);

CREATE TABLE "reviewers" (
  "reviewer_id" INT64 PRIMARY KEY,
  "reviewer_name" STRING,
  "reviewer_email" STRING,
  "reviewer_role" STRING
);

CREATE TABLE "reviewees" (
  "reviewee_internal_id" INT64,
  "reviewee_id" INT64,
  "reviewee_name" STRING,
  "reviewee_email" STRING,
  "reviewee_role" STRING,
  PRIMARY KEY ("reviewee_internal_id", "reviewee_id")
);

CREATE TABLE "comments" (
  "comment_id" INT64 PRIMARY KEY,
  "comment_text" STRING,
  "comment_author_id" INT64,
  "comment_created_at" TIMESTAMP
);

CREATE TABLE "scorecards" (
  "scorecard_id" INT64 PRIMARY KEY,
  "scorecard_tag" STRING,
  "score" FLOAT64,
  "scorecard_name" STRING,
  "scorecard_description" STRING
);

ALTER TABLE "conversations" ADD FOREIGN KEY ("assignee_id") REFERENCES "teams" ("assignee_id");

ALTER TABLE "conversations" ADD FOREIGN KEY ("payment_id") REFERENCES "payments" ("payment_id");

ALTER TABLE "conversations" ADD FOREIGN KEY ("external_ticket_id") REFERENCES "external_tickets" ("external_ticket_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("conversation_created_at") REFERENCES "conversations" ("conversation_created_at");

ALTER TABLE "reviews" ADD FOREIGN KEY ("conversation_created_date") REFERENCES "conversations" ("conversation_created_at_date");

ALTER TABLE "reviews" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("team_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("reviewer_id") REFERENCES "reviewers" ("reviewer_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("reviewee_internal_id") REFERENCES "reviewees" ("reviewee_internal_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("reviewee_id") REFERENCES "reviewees" ("reviewee_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("scorecard_id") REFERENCES "scorecards" ("scorecard_id");

ALTER TABLE "review_ratings" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("review_id");

ALTER TABLE "rating_root_causes" ADD FOREIGN KEY ("rating_id") REFERENCES "review_ratings" ("rating_id");
