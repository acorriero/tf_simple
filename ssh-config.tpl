cat >> ~/.ssh/config << EOF

Host ${hostname}
  Hostname ${hostname}
  User ${user}
  IdentityFile ${identityfile}
EOF