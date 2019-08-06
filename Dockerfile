FROM python:2.7.16

LABEL maintainer="wrodriguezc@ucenfotec.ac.cr"

#install androguard
RUN pip install -U androguard

#Setup SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#Setup SSH access
RUN mkdir --mode=700 /root/.ssh
COPY id_rsa.pub /root/
RUN cat /root/id_rsa.pub >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN rm /root/id_rsa.pub

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]