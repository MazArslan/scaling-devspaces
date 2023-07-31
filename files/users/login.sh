for i in {2..500}
do
    oc login --server= -u user$i -p openshift
done
