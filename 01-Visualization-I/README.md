# Installing RStudio Server on GCP

`create-an-instance.txt` script creates an **n2-highmem-2** instance named **rstudio** that has 2 vCPUs and 16GB of memory and will stop itself once the user is logged out, to bring in cost-saving benefits. At the time of writing, the monthly cost of this instance is about $75/month, if working non-stop. With the auto-stop feature we will bring this cost significantly lower.

## Instructions on Creating the Instance & RStudio Server Installation

The script above needs to be run in the Cloud Shell. But, before executing it you would need to update the "--project" argument. Simply replace `<PROJECT-ID>` with your project ID. Please note that project ID is not necessarily the same as project name. For instance, `--project=ba-780`.

1. **Create the instance:** Once the script is updated copy and paste it to your Cloud Shell. It will take a a minute or so for the instance to be ready. You can confirm this by going to your GCP console > Menu > COMPUTE > Compute Engine. If the instance is ready it will be shown as green (unless it is stopped where it would be grey). If the instance was created but stopped because you didn't log in immediately you can simply select it and hit the START button.
2. **Log in to your instance:** From Cloud Shell run the following command, where `rstudio` is your instance's name:

> `gcloud compute ssh rstudio --zone us-central1-a  -- -L 8080:localhost:8787`

**Note:** if asked for a fingerprint passphrase just hit Enter twice. This is not necessary.

3. **Install R& RStudio:** Run the following lines one at a time to install R & RStudio Server and answer **yes** to the questions (~ 3mins):
```
sudo apt update
sudo apt install r-base r-base-dev libcurl4-openssl-dev libssl-dev libxml2-dev gdebi-core git
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.1335-amd64.deb
sudo gdebi rstudio-server-1.2.1335-amd64.deb
```
4. **Set a password:** If you are logged in as `mohammad@rstudio:~$` you already have a username called `mohammad`. You can set your password by:

> `sudo passwd mohammad`

Pick something simple; your environment is very secure and in addition to this password one needs your Google credentials as well to log in.

You can use the above command to reset your password, in case you forgot it.

5. **(Optional) Add a new user:** By running the following command we will create a new user to access our RStudio Server (replace `<USERNAME>` with the username of your choice). You will be asked to provide a password:
```
sudo adduser <USERNAME>
```

**Note:** once asked for a fingerprint passphrase just hit Enter twice. This is not necessary.

## Log-in to RStudio
1. If you just created your instance it is up and running and you can continue to the next step. If your instance is stopped you would need to "start" it before connecting to it. You can do it in two simple ways:
  * Go to your Compute Engine page, select the instance and click START.
  * From the Cloud Shell run the following command to start an instance called `rstudio`:

> `gcloud compute instances start rstudio --zone us-central1-a`

2. From Cloud Shell run the following command, where `rstudio` is your instance's name:

> `gcloud compute ssh rstudio --zone us-central1-a  -- -L 8080:localhost:8787`

3. Once you see `xxx@rstudio:~$` at the prompt click on the **Web Preview** icon on the top right of Cloud Shell and select preview on port 8080. You should be directed to a new webpage which is the login page of your RStudio Server. Use the username/password you just created to login.

**Note:** Since this is a self-stopping instance anytime you log out of the instance (by closing or exiting the Cloud Shell) your instance will "stop" automatically.

**Note:** Always save your work and push it to your git repository.

## Appendix
A cleaner version of the startup script that has been used in `create-self-stopping-micro-instance.txt` comes below:

```
#!/bin/bash
echo "boot $(date +'%Y%M%d-%H%m%S')" > /tmp/userdata.txt
(
echo "Starting..." >> /tmp/userdata.txt
sleep 600
while true; do
    logins=$(w | sed 1,2d | wc -l)
    echo "[ $(date +'%Y%M%d-%H%m%S') ] Number of logins: ${logins}" >> /tmp/userdata.txt   
    if [ "${logins}" -eq 0 ]; then
        shutdown -h now
    fi
    sleep 10
done
) &
```
