TAG=${1}
mkdir -p ./deploy/.generated
export BUILD_NUMBER=${TAG}
for f in ./deploy/tmpl/*.yml
do
  envsubst < $f > "./deploy/.generated/$(basename $f)"
done

kubectl apply -f ./deploy/.generated/