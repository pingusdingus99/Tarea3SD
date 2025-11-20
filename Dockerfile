FROM danisla/hadoop:2.7.5
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]