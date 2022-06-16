
for name in ${names[@]}; do
   dockerID=$(docker ps | grep $name | awk '{print $1}')
   
   if [[ -f ${name}_bird.conf ]]; then
       echo "== Copy bird.conf to the container: $name"
       docker cp ${name}_bird.conf $dockerID:/etc/bird/bird.conf 

       echo "== Execute 'birdc configure' on the container"
       docker exec $dockerID birdc configure
   else 
       echo "** File ${name}_bird.conf does not exist"
   fi

   echo
done

