explore: autoqa_ratings_test {
  view: autoqa_ratings_test {
    
    # Dimensions
    dimension: autoqa_review_id {
      type: string
      sql: ${TABLE}.autoqa_review_id ;;
    }

    dimension: autoqa_rating_id {
      type: string
      sql: ${TABLE}.autoqa_rating_id ;;
    }

    dimension: payment_id {
      type: number
      sql: ${TABLE}.payment_id ;;
    }

    dimension: team_id {
      type: number
      sql: ${TABLE}.team_id ;;
    }

    dimension: payment_token_id {
      type: number
      sql: ${TABLE}.payment_token_id ;;
    }

    dimension: external_ticket_id {
      type: number
      sql: ${TABLE}.external_ticket_id ;;
    }

    dimension: rating_category_id {
      type: number
      sql: ${TABLE}.rating_category_id ;;
    }

    dimension: rating_category_name {
      type: string
      sql: ${TABLE}.rating_category_name ;;
    }

    dimension: rating_scale_score {
      type: number
      sql: ${TABLE}.rating_scale_score ;;
    }

    dimension: score {
      type: number
      sql: ${TABLE}.score ;;
    }

    dimension: reviewee_internal_id {
      type: number
      sql: ${TABLE}.reviewee_internal_id ;;
    }

    # Measures
    measure: count {
      type: count
      sql: ${TABLE}.autoqa_review_id ;;
    }

    measure: sum_score {
      type: sum
      sql: ${TABLE}.score ;;
    }

    measure: average_score {
      type: average
      sql: ${TABLE}.score ;;
    }

    measure: count_distinct_reviewees {
      type: count_distinct
      sql: ${TABLE}.reviewee_internal_id ;;
    }

    measure: max_score {
      type: max
      sql: ${TABLE}.score ;;
    }

    measure: min_score {
      type: min
      sql: ${TABLE}.score ;;
    }

    # New Measure: Average AutoQA Rating Score when Reviewee Internal IDs are not null
    measure: average_score_non_null_reviewees {
      type: average
      sql: ${TABLE}.score ;;
      filters: [reviewee_internal_id: "-null"]
    }
    

  }
}
