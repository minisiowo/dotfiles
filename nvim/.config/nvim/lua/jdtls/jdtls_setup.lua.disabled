local M = {}

function M:setup()
    local project_name  = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-data/" .. project_name
    vim.fn.mkdir(workspace_dir, "p") -- mkdir -p

    local launcher_pattern = vim.fn.stdpath("data")
        .. "/mason/packages/jdtls/plugins/"
        .. "org.eclipse.equinox.launcher_*.jar"

    local launcher_files = vim.fn.glob(launcher_pattern, true, true)
    local launcher = launcher_files[1]


    local config = {
        cmd = {
            "/usr/lib/jvm/java-21-temurin/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "-jar", launcher, --  ←  tylko ten JAR
            "-configuration", vim.fn.stdpath("data")
        .. "/mason/packages/jdtls/config_linux",
            "-data", workspace_dir,
        },
        root_dir = require("jdtls.setup")
            .find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),
    }

    require("jdtls").start_or_attach(config)
end

return M
