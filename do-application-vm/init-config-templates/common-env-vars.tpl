#cloud-config
merge_how:
 - name: list
   settings: [append]
 - name: dict
   settings: [no_replace, recurse_list]

write_files:
  - path: /etc/environment
    permissions: 0644
    append: true
    content: |
      export ECR_BASE_URL="${ecr_base_url}"
      export COMPOSE_FILES_BUCKET_PATH="${compose_files_bucket_path}"
      export BUCKET_NAME="${bucket_name}"
