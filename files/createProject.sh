# for i in {1.10}
# do
# oc login --server= -u user$i -p openshift
# done

# log onto the oc as cluster admin

for i in {101..110}
do
    # # Create Project On Openshift
    # oc process -f namespace.yaml -p USERNAME=user$i | oc create -f - &
    # sleep 0.5
    # # Gives user access to namespace
    # oc adm policy add-role-to-user admin user$i -n user$i-devspaces

    # # Grant permissions

    # # Config Maps to Be Installeed
    # oc process -f devworkspace-gitconfig.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces

    # # Add missing secrets
    # oc process -f user-preferences.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    # oc process -f user-profile.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces

    # Create the workspace
    oc process -f devworkspace-template.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f devworkspace.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces 
    
done
