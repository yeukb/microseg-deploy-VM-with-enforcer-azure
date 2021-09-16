locals {
    
    user_data = <<EOF
#!/usr/bin/bash
sudo apt-get update && \
sudo apt-get -y upgrade && \
sudo apt-get install -y apache2 && \
sudo systemctl stop ufw && sudo systemctl disable ufw && \
sudo systemctl enable apache2 && \
sudo systemctl restart apache2 && \
TUF_REPO="$(curl -sfSL ${var.cns_api}/_meta/config | sed -n 's/"//g;s/,//;s/.*tuf: //p;')"  && \
RPM_DEB_REPO="$(curl -sfSL ${var.cns_api}/_meta/config | sed -n 's/"//g;s/,//;s/.*repo: //p;')" && \
GPG_KEY="$(curl -sfSL ${var.cns_api}/_meta/config | sed -n 's/"//g;s/,//;s/.*repo-signing-key: //p;')" && \
TUF_REPO_KEY="$(curl -sfSL ${var.cns_api}/_meta/config | sed -n 's/"//g;s/,//;s/.*tuf-keys: //p;')" && \
curl -fsL $GPG_KEY | sudo apt-key add - && \
echo "deb [arch=$(dpkg --print-architecture)] $RPM_DEB_REPO/ubuntu/$(lsb_release -cs) aporeto main" | sudo tee /etc/apt/sources.list.d/aporeto.list && \
sudo apt update && \
sudo apt install -y prisma-enforcer && \
sudo curl -s -o /var/lib/prisma-enforcer/tuf-root-key.json $TUF_REPO_KEY && \
echo "CNS_AGENT_API=${var.cns_api}" | sudo tee /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_TUF_REPO=$TUF_REPO" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_TUF_ROOT_KEY=/var/lib/prisma-enforcer/tuf-root-key.json" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_ENFORCER_FIRST_INSTALL_VERSION=" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_TUF_REPO_CHANNEL_MGR=stable" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_TUF_REPO_CHANNEL_ENFORCER=stable" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "CNS_AGENT_MGR_VERSION=" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "ENFORCERD_API=${var.cns_api}" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "ENFORCERD_NAMESPACE=${var.cns_namespace}" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "ENFORCERD_OPTS=\"\"" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "ENFORCERD_ENABLE_HOST_MODE=true" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
echo "ENFORCERD_ENABLE_CONTAINERS=true" | sudo tee -a /var/lib/prisma-enforcer/prisma-enforcer.conf && \
sudo systemctl enable --now prisma-enforcer && \
sudo systemctl status prisma-enforcer && \
sudo echo "done"
EOF

}