# Snyk-Cloud-GCP

This is a vulnerable by design repository for demonstrating Snyk Cloud. Do not deploy this in production.

## Deployment

To use with ACG - <b> you must first login to the GCP console and accept the terms and enable the cloud resource manager API</b>

Add the following Github Variables:

```
SNYK_ORG
SNYK_TOKEN
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```


To deploy, just commit and push a change in the <b>_build_flag</b> file. This will kick off the Github Action.

## Cleanup

To delete the environment from Snyk Cloud use the UI or the following command:

```
curl -X DELETE \
  'https://api.snyk.io/rest/orgs/YOUR-ORGANIZATION-ID/cloud/environments/YOUR-ENVIRONMENT-ID?version=2022-12-21~beta' \
  -H 'Authorization: token YOUR-SERVICE-ACCOUNT-TOKEN'
```
