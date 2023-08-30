for i in {2..11}
do
oc login --server= -u user$i -p openshift
done

# log onto the oc as cluster admin
# oc login --server= -u user$i -p openshift

for i in {2..11}
do
    # Create Project On Openshift
    oc process -f namespace.yaml -p USERNAME=user$i | oc create -f - &
    sleep 0.5
    # Gives user access to namespace
    oc adm policy add-role-to-user admin user$i -n user$i-devspaces

    # Grant permissions

    # Config Maps to Be Installeed
    oc process -f devworkspace-gitconfig.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces

    # Add missing secrets
    oc process -f user-preferences.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f user-profile.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    
done
