from fedora

RUN dnf install openldap-clients sssd sssd-ldap openssl -y

RUN sed -i 's/passwd:.*/passwd:\ sss\ files/g' /etc/nsswitch.conf && \
    sed -i 's/group:.*/group:\ sss\ files/g' /etc/nsswitch.conf && \
    sed -i 's/netgroup:.*/netgroup:\ sss/g' /etc/nsswitch.conf

COPY ./configs/sssd.conf /etc/sssd/sssd.conf
COPY ./configs/ldap.conf /etc/openldap/ldap.conf

# Retrive certficate used by the ldap server. Otherwise we get certficate errors.
RUN true \
    | openssl s_client -connect 10.0.11.2:636 \
    | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
    > /etc/openldap/certs/ca.crt
#COPY ./secrets/ipa-ca.crt /etc/openldap/certs/ca.crt

RUN chmod 600 /etc/sssd/sssd.conf
RUN chmod 600 /etc/openldap/certs/ca.crt

# Startup
COPY entrypoint.sh .
CMD [ "./entrypoint.sh" ]