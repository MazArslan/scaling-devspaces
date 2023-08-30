# Ensure you login to the cluster as cluster-admin

for i in {2..11}
do
    # Create the workspace template
    oc process -f devworkspace-template.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    # Create the workspace 
    oc process -f devworkspace.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces &
done
