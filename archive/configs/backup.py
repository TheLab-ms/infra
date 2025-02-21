import subprocess
import base64
import os


postgresServers = [
    {
        "hostname": "psql-reporting.default.svc.cluster.local",
        "passwordSecret": "reporting-psql",
        "blobPrefix": "reporting",
    },
    {
        "hostname": "psql-wikijs.default.svc.cluster.local",
        "passwordSecret": "wikijs",
        "blobPrefix": "wikijs",
    },
    {
        "hostname": "psql-keycloak.default.svc.cluster.local",
        "passwordSecret": "keycloak-db",
        "blobPrefix": "keycloak",
    },
]

for psql in postgresServers:
    # Grab the password from its kubernetes secret
    pwordB64 = subprocess.check_output(
        [
            "kubectl",
            "get",
            "secret",
            psql["passwordSecret"],
            "--output=jsonpath={.data.password}",
        ]
    )
    pword = base64.b64decode(pwordB64)

    # pg_dump piped through rclone into azure blob storage
    hostname = psql["hostname"]
    blobPrefix = psql["blobPrefix"]
    subprocess.check_call(
        [
            "/bin/sh",
            "-ec",
            f'pg_dump --host "{hostname}" --username postgres --dbname postgres | rclone rcat sqlbackups:/backups/{blobPrefix}-$(date +"%m-%d-%Y").sql',
        ],
        env=dict(os.environ, PGPASSWORD=pword),
    )

    subprocess.check_call(
        [
            "curl",
            "--fail",
            "https://cronitor.link/p/114679653750431c944a7904780a6a06/JUbC18",
        ]
    )
