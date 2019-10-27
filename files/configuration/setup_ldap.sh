LDAP_CONFIG="/etc/nslcd.conf"

echo "ldap: creating LDAP configuration"

cat <<EoLDAP >$LDAP_CONFIG

uid nslcd
gid ldap

uri $LDAP_URI
filter passwd (&(objectClass=user)(objectClass=person)(!(objectClass=computer)))
base $LDAP_BASE_DN
scope sub

ldap_version 3

EoLDAP

if [ "${LDAP_TLS}" == "true" ] ; then
 echo "ssl start_tls" >> $LDAP_CONFIG
fi

if [ "${LDAP_TLS_VALIDATE_CERT}" == "false" ] ; then
 echo "tls_reqcert no" >> $LDAP_CONFIG
fi

if [ "${LDAP_TLS_CA_CERT}x" != "x" ] ; then

 echo "$LDAP_TLS_CA_CERT" > $OPENVPN_DIR/ldap-ca.crt
 echo "tls_cacertfile ${OPENVPN_DIR}/ldap-ca.crt" >> $LDAP_CONFIG

fi

if [ "${LDAP_FILTER}x" != "x" ] ; then
 echo "filter passwd $LDAP_FILTER" >> $LDAP_CONFIG
fi

if [ "${LDAP_LOGIN_ATTRIBUTE}x" != "x" ] ; then
 echo "map    passwd uid              $LDAP_LOGIN_ATTRIBUTE" >> $LDAP_CONFIG
fi

if [ "${LDAP_BIND_USER_DN}x" != "x" ] ; then

 echo "binddn $LDAP_BIND_USER_DN" >> $LDAP_CONFIG
 echo "bindpw $LDAP_BIND_USER_PASS" >> $LDAP_CONFIG

fi
