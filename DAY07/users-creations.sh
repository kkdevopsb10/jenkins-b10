#!/bin/bash

# =============================================
# Jenkins Multiple User Creation - Shell Script
# =============================================

JENKINS_URL="http://15.207.89.175:8080"

ADMIN_USER="kkfunda"
ADMIN_TOKEN="11d6fea37525fc642d22acae50a747021d"

# username|password|fullname|email
USERS=(
"rrkkd|Dev@12345|Dev User 1|rrd1@gmail.com"
"rrkkd1|Dev@12345|Dev User 1|rrd1@gmail.com"

)

echo "======================================"
echo "      Creating Jenkins Users"
echo "======================================"

for ENTRY in "${USERS[@]}"
do

    IFS='|' read -r USERNAME PASSWORD FULLNAME EMAIL <<< "$ENTRY"

    echo
    echo "Creating user: $USERNAME"

    HTTP_CODE=$(curl -s \
        -o /tmp/jenkins-user-response.txt \
        -w "%{http_code}" \
        --connect-timeout 10 \
        --max-time 30 \
        -u "$ADMIN_USER:$ADMIN_TOKEN" \
        -X POST \
        "$JENKINS_URL/securityRealm/createAccountByAdmin" \
        --data-urlencode "username=$USERNAME" \
        --data-urlencode "password1=$PASSWORD" \
        --data-urlencode "password2=$PASSWORD" \
        --data-urlencode "fullname=$FULLNAME" \
        --data-urlencode "email=$EMAIL")

    if [ "$HTTP_CODE" = "200" ] || \
       [ "$HTTP_CODE" = "302" ] || \
       [ "$HTTP_CODE" = "303" ]; then

        echo "SUCCESS: $USERNAME created"

    else

        echo "FAILED: $USERNAME"
        echo "HTTP Status: $HTTP_CODE"

        cat /tmp/jenkins-user-response.txt

    fi

    echo "--------------------------------------"

done

rm -f /tmp/jenkins-user-response.txt

echo
echo "======================================"
echo "        User Creation Finished"
echo "======================================"
