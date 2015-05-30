#!/bin/bash

export LOCALE=C

if [ "$1" = "" ]; then 
  echo "USAGE: $0 <cfg.env>"; exit 1
fi

if [ ! -f "$1" ]; then 
  echo "ERROR: Configuration file $1 does not exist"; exit 1
else 
  CFGFILE=$1
fi

cnt=`egrep -c "^ORG_NAME" $CFGFILE`
if [ ${cnt} -eq 0 ]; then 
  echo "ERROR: $1 is not a valid configuration file"; exit 1
else
  . $CFGFILE
fi

mkdir -p /root/.hammer
chmod 600 /root/.hammer

HFILE="/root/.hammer/cli_config.yml"

echo ":modules:"                             >  $HFILE
echo "   - hammer_cli_foreman"               >> $HFILE
echo ":foreman:"                             >> $HFILE
echo "  :host: 'https://sat61.rhlab.local/'" >> $HFILE
echo "  :username: '${SAT_ADMIN}'"           >> $HFILE
echo "  :password: '${SAT_PASS}'"            >> $HFILE

cnt=`hammer organization list | grep -c " ${ORG_NAME} "`
if [ ${cnt} -eq 0 ]; then
  hammer organization create --name="${ORG_NAME}" --label=${ORG_LABEL}
  org_id=`hammer organization list | grep " ${ORG_NAME} " | awk '{ print $1 }'`
fi

cnt=`hammer user list | grep -c " rhadmin "`
if [ ${cnt} -eq 0 ]; then
  hammer user create --organizations "${ORG_NAME}" --login ${ORG_ADMIN} --mail "${ORG_ADMIN}@${SATELLITE}" --password="${ORG_PASS}" --auth-source-id 1 --admin 1 --default-organization-id ${org_id}
hammer organization add-user --user=${ORG_ADMIN} --name="${ORG_NAME}"
fi

# Create two new lifecycle environments  
hammer lifecycle-environment info --name DEV --organization="${ORG_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  hammer lifecycle-environment create --name='DEV' --prior='Library' --organization="${ORG_NAME}"
fi

hammer lifecycle-environment info --name QE --organization="${ORG_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  hammer lifecycle-environment create --name='QE' --prior='DEV' --organization="${ORG_NAME}"  
fi

hammer lifecycle-environment info --name PROD --organization="${ORG_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  hammer lifecycle-environment create --name='PROD' --prior='QE' --organization="${ORG_NAME}"  
fi


# Upload our manifest.zip (created in RH Portal) to our org
# hammer subscription list --organization "Red Hat Demo"
cnt=`hammer subscription list --organization "${ORG_NAME}" | wc -l`
if [ ${cnt} -eq 3 ]; then
  hammer subscription upload --file /root/manifest.zip --organization="${ORG_NAME}"
fi

# --- CREATE PRODUCT ---
hammer product info --name "Red Hat Enterprise Linux Server" --organization="${ORG_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  hammer product create --name='Red Hat Enterprise Linux Server' --organization "${ORG_NAME}"
fi


if [ ${REPO_RHEL6} -eq 1 ]; then 
  # Red Hat Enterprise Linux 6 Server (Kickstart) 
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server (Kickstart)'

  # Red Hat Enterprise Linux 6 Server (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Extras (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Extras (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Fastrack (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Fastrack (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Optional (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Optional (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Optional Fastrack (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Optional Fastrack (RPMs)'

  # Red Hat Enterprise Linux 6 Server - RH Common (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - RH Common (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Supplementary (RPMs) 
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Supplementary (RPMs)'
fi

if [ ${REPO_RHEL7} -eq 1 ]; then 
  # Red Hat Enterprise Linux 7 Server (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Optional (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Optional (RPMs)'  

  # Red Hat Enterprise Linux 7 Server - Extras (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Extras (RPMs)'

  # Red Hat Enterprise Linux 7 Server - RH Common (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - RH Common (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Optional Fastrack (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Optional Fastrack (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)'

  # RHN Tools for Red Hat Enterprise Linux 7 Server (RPMs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'RHN Tools for Red Hat Enterprise Linux 7 Server (RPMs)'

  # Red Hat Enterprise Linux 7 Server (ISOs)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (ISOs)'

  # Red Hat Enterprise Linux 7 Server (Kickstart)
  hammer repository-set enable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (Kickstart)'
fi
exit

# --- CREATE PRODUCT ---
hammer product create --name='EPEL' --organization "${ORG_NAME}"

if [ ${REPO_EPEL6} -eq 1 ]; then 
  hammer repository create --name='EPEL 6 - x86_64' --organization "${ORG_NAME}" --product='EPEL' --content-type='yum' --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/6/x86_64/
fi

if [ ${REPO_EPEL7} -eq 1 ]; then 
  hammer repository create --name='EPEL 7 - x86_64' --organization "${ORG_NAME}" --product='EPEL' --content-type='yum' --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/7/x86_64/
fi


# --- CREATE PUPPET FORGE ---
hammer product create --name='Forge' --organization "${ORG_NAME}"

hammer repository create --name='Puppet Forge' --organization "${ORG_NAME}" --product='Forge' --content-type='puppet' --publish-via-http=true --url=https://forge.puppetlabs.com

# --- CREATE CONTENT VIEW ---
if [ ${REPO_RHEL6} -eq 1 ]; then 
  hammer content-view create --name='rhel-6-server-x86_64-cv' --organization "${ORG_NAME}"

  for n in $(hammer --csv repository list --organization "${ORG_NAME}" | grep "Linux 6 Server" | awk -F, {'print $1'} | grep -vi '^ID'); do
    hammer content-view add-repository --name rhel-6-server-x86_64-cv --organization "${ORG_NAME}" --repository-id ${n};
  done

  if [ ${REPO_EPEL6} -eq 1 ]; then 
    for n in $(hammer --csv repository list --organization "${ORG_NAME}" | grep "EPEL 6" | awk -F, {'print $1'} | grep -vi '^ID'); do
      hammer content-view add-repository --name rhel-6-server-x86_64-cv --organization "${ORG_NAME}" --repository-id ${n};
    done
  fi
fi

# --- CREATE CONTENT VIEW ---
if [ ${REPO_RHEL7} -eq 1 ]; then
  hammer content-view create --name='rhel-7-server-x86_64-cv' --organization "${ORG_NAME}"

  for n in $(hammer --csv repository list --organization "${ORG_NAME}" --content-type yum | grep "Linux 7 Server" | awk -F, {'print $1'} | grep -vi '^ID'); do
    hammer content-view add-repository --name rhel-7-server-x86_64-cv --organization "${ORG_NAME}" --repository-id ${n};
  done

  if [ ${REPO_EPEL6} -eq 1 ]; then
    for n in $(hammer --csv repository list --organization "${ORG_NAME}" --content-type yum | grep "EPEL 7" | awk -F, {'print $1'} | grep -vi '^ID'); do
      hammer content-view add-repository --name rhel-7-server-x86_64-cv --organization "${ORG_NAME}" --repository-id ${n};
    done
  fi
fi

exit

#for i in $(hammer --csv repository list --organization "${ORG_NAME}" | awk -F, {'print $1'} | grep -vi '^ID'); do 
#  hammer content-view add-repository --name='rhel-7-server-x86_64-cv' --organization "${ORG_NAME}" --repository-id=${i}; 
#done



# --- CREATE HOST-GROUP ---
# hammer hostgroup create --help


