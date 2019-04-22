# make clean script for docker

[Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US';
Write-Warning "This script wipes the whole docker host of containers, images, networks and volumes!"
Write-Warning "Proceed? (yN)"
$n = Read-Host 
if ($n -ne 'y') { exit }

# containers
Write-Host ">> Stopping containers";
docker container ls -a | Select-Object -Skip 1 | ForEach-Object  { 
	$id = @($_ -split '\s+')[0];
	Write-Host $id;
	docker container stop $id
	docker container rm --force --volumes $id
} 

# images
Write-Host ">> Removing images"
docker image ls | Select-Object -Skip 1 | ForEach-Object { 
	$id = @($_ -split '\s+')[2] 
	Write-Host $id
	docker image rm --force $id
} 
docker image prune --all --force

# volumes
Write-Host ">> Deleting volumes"
docker volume ls | Select-Object -Skip 1 | ForEach-Object { 
	$id = @($_ -split '\s+')[1] 
	Write-Host $id
	docker volume rm $id
} 
docker volume prune --force

# networks
Write-Host ">> Deleting networks"
docker network prune --force