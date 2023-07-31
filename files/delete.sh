for i in {2..100}
do
    oc delete devworkspace -l demo=scaling -n user$i-devspaces
    oc delete devworkspacetemplate che-code-web-frontend -n user$i-devspaces
done