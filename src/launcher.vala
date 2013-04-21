/*
 * Copyright (C) 2013  Paolo Borelli <pborelli@gnome.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

class Application : Gtk.Application {
    static bool print_version;
    const OptionEntry[] option_entries = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version, N_("Print version information and exit"), null },
        { null }
    };

    public Application () {
        Object (application_id: "org.gnome.clocks", flags: ApplicationFlags.IS_LAUNCHER);
    }

    protected override bool local_command_line ([CCode (array_length = false, array_null_terminated = true)] ref unowned string[] arguments, out int exit_status) {
        var ctx = new OptionContext ("");

        ctx.add_main_entries (option_entries, Config.GETTEXT_PACKAGE);
        ctx.add_group (Gtk.get_option_group (true));

        // Workaround for bug #642885
        unowned string[] argv = arguments;

        try {
            ctx.parse (ref argv);
        } catch (Error e) {
            exit_status = 1;
            return true;
        }

        if (print_version) {
            print ("%s %s\n", Environment.get_application_name (), Config.VERSION);
            exit_status = 0;
            return true;
        }

        return base.local_command_line (ref arguments, out exit_status);
    }
}

int main (string[] args) {
    Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.GNOMELOCALEDIR);
    Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
    Intl.textdomain (Config.GETTEXT_PACKAGE);

    var app = new Application ();
    return app.run (args);
}
