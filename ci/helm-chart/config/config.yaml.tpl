# The usernames and passwords must match the ones in the htpasswd files for each server.
lcp_update_auth:
    # login and password used by the Status Server to access the License Server
    username: "{{ .Values.auth.username }}"
    password: "{{ .Values.auth.password }}"

lsd_notify_auth:
    # login and password used by the License Server to access the Status Server
    username: "{{ .Values.auth.username }}"
    password: "{{ .Values.auth.password }}"

# LCP Server

profile: "{{ .Values.profile }}"
lcp:
    host: "127.0.0.1"
    # the public url a client app will use to access the License Server (optional)
    public_base_url:  "{{ .Values.lcp.public_base_url }}"
    # the port on which the License Server will be running
    port: 8989
    # replace this dsn if you're not using SQLite
    database: "{{ .Values.lcp.database }}"
    # authentication file of the License Server. Here we use the same file for the License Server and Status Server
    auth_file: "/app/.htpasswd"
{{- if .Values.storage.enabled }}
storage:
   filesystem:
       directory: "/data/files/storage"
{{- end }}
certificate:
    # theses test certificates are provided in the test/cert folder of the codebase
    cert: "/app/cert/{{ .Values.certName }}.crt"
    private_key: "/app/cert/{{ .Values.certName }}.key"
license:
    links:
        # leave the url as-is (after <LSD_SERVER> has been resolved)
        status: {{ default ( tpl "{{ .Values.lsd.public_base_url }}/licenses/{license_id}/status" . ) .Values.links.status | quote }}
        # the url of a REAL html page, that indicates how the user can get back his passphrase if forgotten
        hint: "{{ .Values.links.hint }}"


# LSD Server

lsd:
    host: "127.0.0.1"
    # the public url a client app will use to access the Status Server
    public_base_url:  "{{ .Values.lsd.public_base_url }}"
    # the port on which the Status Server will be running
    port: 8990
    # replace this dsn if you're not using SQLite
    database: "{{ .Values.lsd.database }}"
    # authentication file of the Status Server. Here we use the same file for the License Server and Status Server
    auth_file: "/app/.htpasswd"
    # in this example, the License Gateway is developed so that adding a license id
    # to the host name gives access to a fresh license.
    # Keep {license_id} as-is; this is a template.
    # Read the doc to know more about how to develop a License Gateway.
    license_link_url: {{ default ( tpl "{{ .Values.lcp.public_base_url }}/licenses/{license_id}" . ) .Values.links.license | quote }}

license_status:
{{ toYaml .Values.license_status | indent 2 }}
