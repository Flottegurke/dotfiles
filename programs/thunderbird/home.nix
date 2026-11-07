{ lib, config, osConfig, ... }:
lib.mkIf osConfig.programs.thunderbird.enable {
  programs.thunderbird = {
    enable = true;

    settings = {
      "mailnews.message_display.disable_remote_image" = true; # block remote tracking pixels
      "mail.phishing.detection.enabled" = true;
      "mail.trusteddomains" = ""; # no globally trusted sender domains
      "mail.compose.attach_http_images" = false;
      "mailnews.display.html_as" = 0;

      "mailnews.default_sort_type" = 18; # by date for newly created folders
      "mailnews.default_sort_order" = 2; # newest first for newly created folders
      "mailnews.default_view_flags" = 1; # threaded view for new folders
      "mailnews.sort_threads_by_root" = false; # sort threads by newest message
      "mail.showCondensedAddresses" = false; # show addresses more explicitly
      "mailnews.headers.showSender" = false;
      "mailnews.nav_crosses_folders" = 1; # confirm moving to unread messages in other folders
      "mail.operate_on_msgs_in_collapsed_threads" = false;
      "mail.warn_on_collapsed_thread_operation" = true;

      "mailnews.mark_message_read.auto" = true;
      "mailnews.mark_message_read.delay" = true;
      "mailnews.mark_message_read.delay.interval" = 3; # seconds
      "mailnews.threadpane_select_delay" = 250; # milliseconds
      "mail.warn_on_shift_delete" = true;
      "mail.warn_on_delete_from_trash" = true;
      "mailnews.emptyTrash.dontAskAgain" = false;
      "mailnews.emptyJunk.dontAskAgain" = false;

      "mail.spellcheck.inline" = true;
      "mail.SpellCheckBeforeSend" = false; # inline spellchecking instead of a send-time dialog
      "mail.compose.autosave" = true;
      "mail.compose.autosaveinterval" = 2; # minutes
      "mail.compose.default_to_paragraph" = true;
      "mailnews.wraplength" = 72;
      "mailnews.send_plaintext_flowed" = true;
      "mail.default_send_format" = 0; # automatic format selection
      "mail.compose.add_undisclosed_recipients" = true;
      "mail.warn_on_send_accel_key" = true; # confirm Ctrl+Enter sending
      "mailnews.reply_header_type" = 2; # date + sender when quoting
      "mailnews.reply_quoting_selection" = true;
      "mail.forward_message_mode" = 2; # forward inline
      "mail.forward_add_extension" = true;
      "mail.enable_autocomplete" = true;

      "mail.receipt.request_return_receipt_on" = false;
      "mail.dsn.always_request_on" = false;
      "mail.mdn.report.not_in_to_cc" = 2; # ask
      "mail.mdn.report.outside_domain" = 2; # ask
      "mail.mdn.report.other" = 2; # ask

      "mail.notification.count.inbox_only" = true;

      "rss.show.summary" = 1; # summary instead of the remote web page
      "mailnews.default_news_sort_type" = 18;
      "mailnews.default_news_sort_order" = 2;
      "mailnews.default_news_view_flags" = 1;

      "browser.download.useDownloadDir" = false; # ask on each attachment
      "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

      "mailnews.database.global.indexer.enabled" = true; # faster global search, more indexing
    };

    profiles.default = {
      isDefault = true;

      settings = {
        "extensions.autoDisableScopes" = 0; # auto-enable declarative extensions
      };

      # extensions = [ ];
    };
  };
}

