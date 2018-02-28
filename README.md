# Technical Solutions Testing Example

This repository holds an example Hello World set of manifests that can be used
to demonstrate how to test your solutions regularly and realistically using
the [Solutions Architects Concourse CI Server](https://concourse.dev.vicnastea.io).

# Instructions

## Configuration
1. Copy the `tests` folder to your repository.

1. For receiving emails you will need an SMTP provider
   ([SendGrid](https://sendgrid.com/docs/API_Reference/SMTP_API/getting_started_smtp.html),
   [MailChimp](https://mandrill.zendesk.com/hc/en-us/categories/200277207-SMTP-Integration), etc). Ensure that
   you can use a port that is not blocked on GCE, for example 2525.

1. Once you have credentials and endpoints for your SMTP provider, fill them into the [parameters file](tests/parameters.yaml)

1. Add the email that you want your CI failures to go to in the `maintainer_email` field.

1. Create a GCP service account that has enough permission to run your tutorial/code. Get its JSON key and add that
   to the [parameters file](tests/parameters.yaml) in `service_account_json`.

## Create the pipeline
1. Once you have your parameters set, you need to login to Concourse.

1. Download the `fly` CLI which actuates the Concourse API.

    ````shell
    # For Mac
    wget https://concourse.dev.vicnastea.io/api/v1/cli?arch=amd64&platform=darwin

    # For Linux
    wget https://concourse.dev.vicnastea.io/api/v1/cli?arch=amd64&platform=linux

    # For Windows
    wget https://concourse.dev.vicnastea.io/api/v1/cli?arch=amd64&platform=windows -OutFile fly.exe
    ````

 1. Login to Concourse:

    ```shell
    ./fly -t main login --concourse-url https://concourse.dev.vicnastea.io
    ```

 1. When prompted use the Github Login option, and follow the prompts to complete the authentication.

 1. Upload your pipeline and give it a unique name.

    ```shell
    fly -t main set-pipeline -p <your-pipeline-name> -c tests/pipelines/run-tutorial.yaml -l tests/parameters.yaml
    ```

 1. Unpause the pipeline to have it start checking your source code for changes:

    ```shell
    fly -t main unpause-pipeline -p <your-pipeline-name>
    ```

1. You can now login to the Concourse web interface to see your pipeline's status. In your browser go to:

    ```
    https://concourse.dev.vicnastea.io/teams/main/pipelines/<your-pipeline-name>
    ```

 ## Running your pipeline steps manually

 One nice feature of Concourse is the ability to run your pipeline via Concourse but using your local source
 code. This allows you to iterate on your tests and code easily without having to make intermediate commits.

 1. Ensure you are logged in with Fly.

    ```shell
    fly -t main login
    ```

 1. Add your service account JSON to an environment variable called `service_account_json`.

    ```shell
    export service_account_json=$(cat my-service-account.json)
    ```

 1. In your source code directory run:

    ```shell
    fly -t main execute -c tests/tasks/run-tutorial.yaml -j <your-pipeline-name>/test-tutorial
    ```
