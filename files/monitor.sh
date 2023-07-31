echo 'oc adm top nodes'
oc adm top nodes >> nodes.txt
echo 'oc get pods -A -o wide -l controller.devfile.io/devworkspace_id'
oc get pods -A -o wide -l controller.devfile.io/devworkspace_id >> pods.txt