#!/bin/bash

#hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server'  --name "Red Hat Enterprise Linux 6 Server (RPMs)" --basearch='i386' --releasever='6Server'


. ./satellite_setup.env

# --- CREATE CONTENT VIEW ---
if [ ${REPO_RHEL6} -eq 1 ]; then 
  # -- REMOVE REPOSITORIES ---
  for n in $(hammer --csv content-view list --organization "${ORG_NAME}" --name rhel-6-server-x86_64-cv | \
    sed -e 's/"$//g' -e 's/^.*"//g' -e 's/,//g'); do
    hammer content-view remove-repository --name rhel-6-server-x86_64-cv --organization "${ORG_NAME}" --repository-id $n
  done

  hammer content-view delete --name='rhel-6-server-x86_64-cv' --organization "${ORG_NAME}"
fi

# --- CREATE CONTENT VIEW ---
if [ ${REPO_RHEL7} -eq 1 ]; then
  # -- REMOVE REPOSITORIES ---
  for n in $(hammer --csv content-view list --organization "${ORG_NAME}" --name rhel-7-server-x86_64-cv | \
    sed -e 's/"$//g' -e 's/^.*"//g' -e 's/,//g'); do
    hammer content-view remove-repository --name rhel-7-server-x86_64-cv --organization "${ORG_NAME}" --repository-id $n
  done

  hammer content-view delete --name='rhel-7-server-x86_64-cv' --organization "${ORG_NAME}"
fi

# --- REMOVE PRODUCTS ---
if [ ${REPO_RHEL6} -eq 1 ]; then 
  # Red Hat Enterprise Linux 6 Server (Kickstart) 
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server (Kickstart)'

  # Red Hat Enterprise Linux 6 Server (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Extras (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Extras (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Fastrack (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Fastrack (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Optional (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Optional (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Optional Fastrack (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Optional Fastrack (RPMs)'

  # Red Hat Enterprise Linux 6 Server - RH Common (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - RH Common (RPMs)'

  # Red Hat Enterprise Linux 6 Server - Supplementary (RPMs) 
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='6Server' \
  --name 'Red Hat Enterprise Linux 6 Server - Supplementary (RPMs)'
fi

if [ ${REPO_RHEL7} -eq 1 ]; then 
  # Red Hat Enterprise Linux 7 Server (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Optional (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Optional (RPMs)'  

  # Red Hat Enterprise Linux 7 Server - Extras (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Extras (RPMs)'

  # Red Hat Enterprise Linux 7 Server - RH Common (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - RH Common (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Optional Fastrack (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Optional Fastrack (RPMs)'

  # Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)'

  # RHN Tools for Red Hat Enterprise Linux 7 Server (RPMs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'RHN Tools for Red Hat Enterprise Linux 7 Server (RPMs)'

  # Red Hat Enterprise Linux 7 Server (ISOs)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (ISOs)'

  # Red Hat Enterprise Linux 7 Server (Kickstart)
  hammer repository-set disable --organization "${ORG_NAME}" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (Kickstart)'
fi

hammer product delete --name='Red Hat Enterprise Linux Server' --organization "${ORG_NAME}"

# --- REMOVE PRODUCT ---
hammer product delete --name='Red Hat Enterprise Linux Server' --organization "${ORG_NAME}"
if [ ${REPO_EPEL6} -eq 1 ]; then
  hammer repository delete --name='EPEL 6 - x86_64' --organization "${ORG_NAME}" --product='EPEL'
fi

if [ ${REPO_EPEL7} -eq 1 ]; then
  hammer repository delete --name='EPEL 7 - x86_64' --organization "${ORG_NAME}" --product='EPEL'
fi

hammer product delete --name='EPEL' --organization "${ORG_NAME}"

# --- CREATE PUPPET FORGE ---
hammer repository delete --name='Puppet Forge' --organization "${ORG_NAME}" --product='Forge' 

hammer product delete --name='Forge' --organization "${ORG_NAME}"


# --- REMOVE SUBSCRIPTIONS ---
cnt=`hammer subscription list --organization "${ORG_NAME}" | wc -l`
if [ ${cnt} -ne 3 ]; then
  hammer subscription delete-manifest --organization "${ORG_NAME}"
fi

cnt=`hammer user list | grep -c " rhadmin "`
if [ ${cnt} -eq 1 ]; then
  id=`hammer user list | grep rhadmin | awk '{ print $1 }'`
  hammer user delete --id ${id}
fi

hammer lifecycle-environment delete --name 'PROD' --organization="${ORG_NAME}"
hammer lifecycle-environment delete --name 'QE' --organization="${ORG_NAME}"
hammer lifecycle-environment delete --name 'DEV' --organization="${ORG_NAME}"

exit
# hammer subscription list --organization " ${ORG_NAME} "
cnt=`hammer organization list | grep -c " ${ORG_NAME} "`
if [ ${cnt} -eq 1 ]; then
  hammer organization delete --name "${ORG_NAME}"
fi


