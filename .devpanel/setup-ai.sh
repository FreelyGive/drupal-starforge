if [ -n "${DP_AI_VIRTUAL_KEY:-}" ]; then
  time drush pm:en -y ai ai_provider_litellm ai_agents
  echo
  drush -n key-save litellm_api_key --label="LiteLLM API key" --key-provider=env --key-provider-settings='{
    "env_variable": "DP_AI_VIRTUAL_KEY",
    "base64_encoded": false,
    "strip_line_breaks": true
  }'
  drush -n cset ai_provider_litellm.settings api_key litellm_api_key
  drush -n cset ai_provider_litellm.settings moderation false --input-format yaml
  drush -n cset ai_provider_litellm.settings host "https://ai.drupalforge.org"
  drush -n cset ai.settings default_providers.chat.provider_id litellm
  drush -n cset ai.settings default_providers.chat.model_id openai/gpt-4.1
  drush -n cset ai.settings default_providers.chat_with_complex_json.provider_id litellm
  drush -n cset ai.settings default_providers.chat_with_complex_json.model_id openai/gpt-4.1
  drush -n cset ai.settings default_providers.chat_with_image_vision.provider_id litellm
  drush -n cset ai.settings default_providers.chat_with_image_vision.model_id openai/gpt-4.1
  drush -n cset ai.settings default_providers.chat_with_structured_response.provider_id litellm
  drush -n cset ai.settings default_providers.chat_with_structured_response.model_id openai/gpt-4.1
  drush -n cset ai.settings default_providers.chat_with_tools.provider_id litellm
  drush -n cset ai.settings default_providers.chat_with_tools.model_id openai/gpt-4.1
  drush -n cset ai.settings default_providers.embeddings.provider_id litellm
  drush -n cset ai.settings default_providers.embeddings.model_id openai/text-embedding-3-small
  drush -n cset ai.settings default_providers.text_to_speech.provider_id litellm
  drush -n cset ai.settings default_providers.text_to_speech.model_id openai/gpt-4o-mini-realtime-preview

  # Check if psql is installed.
  if command -v psql >/dev/null 2>&1; then
    time drush pm:en -y ai_vdb_provider_postgres ai_search
    drush -n key-save postgres_db_password --label="Postgres DB Password" --key-provider=config --key-provider-settings='{
      "key_value": "db"
    }'
    drush -n cset ai_vdb_provider_postgres.settings password postgres_db_password
    if env | grep -q DDEV_PROJECT; then
      drush -n cset ai_vdb_provider_postgres.settings host pgvector
    else
      drush -n cset ai_vdb_provider_postgres.settings host localhost
    fi
    drush -n cset ai_vdb_provider_postgres.settings port 5432
    drush -n cset ai_vdb_provider_postgres.settings default_database db
    drush -n cset ai_vdb_provider_postgres.settings username db
  fi

  # Get AI Image Alt Text
  composer require drupal/ai_image_alt_text

  # Flush the cache.
  drush cr

  # Apply the localgov_ai recipe.
  drush recipe ../recipes/localgov_ai

  # Do this 16 times (80 contents).
  for i in {1..16}; do
    # Wait for 5 seconds to not run into rate limits.
    sleep 5
    # Start indexing.
    drush sapi-i content_for_ai --limit=5
  done
fi
