# ubi8-google-api-python-client

A utility image that is the UBI8 image the [google-api-python-client](https://github.com/googleapis/google-api-python-client) and dependent libraries.

## Purpose

Useful for environments where these libraries/tools are needed such as:
* local development
* CI tools that do not require specific CI tooling configuraiton, such as GiLab Jobs.

## Helper Scripts

This image also contains custom helper scripts for interacting with the Google API.

### upload-file-to-google-drive.py
This script makes an easy way for uploading files to Google Drive into existing or new folders.

#### Parameters

| parameter                | required | default | comments
|--------------------------|----------|---------|---------
| --credentials            | yes      |         | A JSON file with google API crednetials.
| --drive-id               | no       |         | If wanting to upload to a Google Team Share drive then this is where to specivy that share drive id.
| --file                   | yes      |         | Local file path of the file to upload.
| --parent-drive-folder-id | yes      |         | Google Drive Folder ID to be the parent of the file (or sub folder containing the file if sub-folder-name supplied).
| --sub-folder-name        | no       |         | Name of a sub folder to create (if it doesn't exist) under the parent-drive-folder-id folder to then put the uploaded file in.
| --destination            | yes      |         | Name of the file when uploaded to Google Drive.
| --dest-mime-type         | no       | `application/vnd.google-apps.document`                                    | MIME type of the destination file once uploaded, this can be used to have google automatically convert a file from one type to another, say from DOCX to gDoc.
| --source-mime-type       | no       | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` | MIME type of the source file.

#### Getting a credentials.json
There are many ways to do this. The way in which the author of this script did it was to follow steps from
[How to use GCP service accounts with Google Apps Script projects to automate actions in G Suite](How to use GCP service accounts with Google Apps Script projects to automate actions in G Suite) specfiically "SECTION TWO: Create a GCP project, a service account, activate the Google Drive API, and an API key". No matter the instructions you follow
ultimatlly what you need to end up looks like the following.

credentials.json Example
```json
{
  "api_key": "xxxxxxx",
  "type": "service_account",
  "project_id": "GOOGLE_CLOUD_PROJECT_NAME",
  "private_key_id": "xxxxx",
  "private_key": "-----BEGIN PRIVATE KEY-----\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n-----END PRIVATE KEY-----\n",
  "client_email": "SERVICE_ACCOUNT_NAME@GOOGLE_CLOUD_PROJECT_NAME.iam.gserviceaccount.com",
  "client_id": "00000000000000000000000",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/SERVICE_ACCOUNT_NAME%40GOOGLE_CLOUD_PROJECT_NAME.iam.gserviceaccount.com"
}
```

#### Examples

Generic Example
```bash
upload-file-to-google-drive \
  --file=${LOCAL_FILE_PATH_TO_UPLOAD} \
  --drive-id="${GOOGLE_DRIVE_ID}" \
  --parent-drive-folder-id="${GOOGLE_DRIVE_PARENT_FOLDER_ID}" \
  --sub-folder-name="${GOOGLE_DRIVE_SUB_FOLDER_NAME_UNDER_PARENT_DRIVE_FOLDER_ID_TO_UPLOAD_FILE_TO}" \
  --destination="${GOOGLE_DRIVE_FILE_NAME}" \
  --dest-mime-type='${DESTINATION_FILE_TYPE}' \
  --source-mime-type='${SOURCE_MIME_TYPE}' \
  --credentials="${google_api_credentials_json}"
```

Upload DOCX and convert to GDOC
```bash
upload-file-to-google-drive \
  --file=foo.docx \
  --drive-id="${GOOGLE_DRIVE_ID}" \
  --parent-drive-folder-id="${GOOGLE_DRIVE_PARENT_FOLDER_ID}" \
  --sub-folder-name="bar" \
  --destination="foo" \
  --dest-mime-type='application/vnd.google-apps.document' \
  --source-mime-type='application/vnd.openxmlformats-officedocument.wordprocessingml.document' \
  --credentials="${google_api_credentials_json}"
```

## Published

[https://quay.io/repository/redhat-cop/ubi8-google-api-python-client](https://quay.io/repository/redhat-cop/ubi8-google-api-python-client) via [GitHub Workflows](../../.github/workflows/ubi8-google-api-python-client-publish.yaml).
