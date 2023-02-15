# Dev-spaces, Automating Workspaces

This is an investigation into automating the creation of Dev Workspaces using a Declarative approach.

The idea was to be able to automate the process to enable testing at scale.

Requirements:
1. A Openshift 4.10 (or above)
2. Admin access to OCP

For my investigation I used, RHPDS.

## Users

Initially when you create your OCP 4.10 cluster on RHPDS, you only have `opentlc-mgr` (Cluster Admin) and `user1`, for scaling testing 2 users are not sufficient. so we need to create more users.

For this, I've created a script to creates a htpasswd file so we can use htpasswd authentication on openshift

Using `files/users/create_user.sh`, it creates htpasswd file. it currently creates 170 users. 

To add users on openshift, `Administration` -> `custom resource definitions` -> `oauth` -> `instances` -> `oauth cluster instance` -> `identity providers` -> `add` and add the htpasswd file.

this creates another provider, but it works

Don't forget to use the `users/login.sh` script. THIS TAKES LONG. 
Else you will have a error when you run the `createProjects.sh` saying that user doesn't exist.   

Don't forget to login as the cluster admin afterwards

## Dev Spaces Operator

Install OpenShift Dev spaces in openshift operators And create a instance.

## Automating

`file/createProject.sh` is a script that runs through all the following steps.

it currently does it for 10 Users so please modify before use. 

### Namespace
The first stage to creating a automated process is to create a project/namespace.

When you log into Openshift Dev Spaces, it creates a namespace with the name `<username>-devspaces`. It also adds labels the namespace, letting it know that it is a part of `che.eclipse.org` 

`files/workspace/namespace.yaml` automates this step. 

### Oauth Client Authentication

Whenever a user logs onto Dev Workspaces for the first time, you are greeting the an OAuth request.
`openshift-operators-client` wants to be able get full user access.

`files/workspace/auth.yaml` provides a template to enable this to happen without a manual step.

### Config Maps

When we initially create the namespace and add labels to it. Kubernetes automatically adds certain configmaps relating to `eclipse.che` to our project.
However we are missing 3 configmaps, these are normally generated when a user initially logs onto the system using the UI . 
These config maps all relate to a developer experience. 
these include:
1. devworkspace-gitconfig
2. workspace-preferences-configmap
3. workspace-userdata-gitconfig-configmap

these config maps include information about a user's name, username, email and git credentials.

there are 3 separate templates for each missing config map. See `files/configmaps/` to have a look.

### Secrets

Similarly, we are missing 3 secrets.
they relate to:
1. user-preferences
2. user-profile
3. workspace-credentials-secret

see `files/secrets/` for more information

### Dev Space

the final 2 things to create, is the dev workspace itself.
this is split into 2 sections, a `DevWorkspaceTemplate` and `DevWorkspace`.

#### Workspace Template

The workspace template is for the IDE of the application. my current template uses the default `che-theia` IDE.

#### Dev Workspace

This is where the `devfile` lives. it contains all the information regarding the git repo and project. 

## Git Auth

So far all of this has been tested using public GitHub.
As with most companies, you normally use a private github instance.
For this demo, we will be using 'gitlab.consulting.redhat.com'

when you try to use any form of a internal github without enabling github OAuth, it will say that there is no valid devfile.

follow these instructions to enable OAuth on gitlab and devspaces:

https://access.redhat.com/documentation/en-us/red_hat_openshift_dev_spaces/3.2/html/administration_guide/configuring-che#setting-up-the-gitlab-authorized-application

Once the authentication has been completed, you need to enable the authentication. 
this can be done by trying to create a dev-space using a repo from the gitlab instance. 

Once authentication has been enabled, you can use any repo without having to reauthenticate per user.
this enables you to automate everything else `create-gitlab.sh`.

## Other things of note

Without the secrets and configmaps, you can create a dev space, however the dev space does not actually run properly. 
This is because the IDE is expecting some sort of user credentials/preferences. 
The pods will be running, but when you try to go on the workspace, the replication controller will delete those pods and create new pods with the correct configuration. 
 
