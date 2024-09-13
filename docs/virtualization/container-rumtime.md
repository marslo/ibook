
| docker             | ctr                          | crictl               |
|--------------------|------------------------------|----------------------|
| docker             | ctr（containerd）            | crictl（kubernetes） |
| docker ps          | ctr task ls/ctr container ls | crictl ps            |
| docker images      | ctr image ls                 | crictl images        |
| docker logs        | -                            | crictl logs          |
| docker inspect     | ctr container info           | crictl inspect       |
| docker stats       | -                            | crictl stats         |
| docker start/stop  | ctr task start/kill          | crictl start/stop    |
| docker run         | ctr run                      | -                    |
| docker tag         | ctr image tag                | -                    |
| docker create      | ctr container create         | crictl create        |
| docker load        | ctr image import             | -                    |
| docker save        | ctr image export             | -                    |
| docker rm          | ctr container rm             | crictl rm            |
| docker rmi         | ctr image rm                 | crictl rmi           |
| docker pull        | ctr image pull               | ctictl pull          |
| docker push        | ctr image push               | -                    |
| docker exec        | -                            | crictl exec          |
| docker image prune | -                            | crictl rmi --prune   |
