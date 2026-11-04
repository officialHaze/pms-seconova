// Every external link on Settings > Help, in one place. Not overridable by
// self-hosted admins in v1 — to add that later, change only this file.
export const WORKLENZ_DOCS_URL = '';
export const WORKLENZ_STATUS_DOCS_URL = '';
export const WORKLENZ_CHANGELOG_URL = '';

export const WORKLENZ_YOUTUBE_URL = '';

export const WORKLENZ_DISCORD_URL = '';
export const WORKLENZ_GITHUB_URL = '';
export const WORKLENZ_FACEBOOK_URL = '';
export const WORKLENZ_LINKEDIN_URL = '';
export const WORKLENZ_X_URL = '';

export const WORKLENZ_PRIVACY_POLICY_URL = '';

// Email support opens the user's mail app (no page, no new tab). The subject is
// prefilled and deliberately not localized: it is addressed to the support team,
// which triages in English.
export const WORKLENZ_SUPPORT_EMAIL = 'developer@seconova.ai';
export const WORKLENZ_SUPPORT_EMAIL_SUBJECT = 'Secteams support request';
export const WORKLENZ_SUPPORT_MAILTO_URL = `mailto:${WORKLENZ_SUPPORT_EMAIL}?subject=${encodeURIComponent(WORKLENZ_SUPPORT_EMAIL_SUBJECT)}`;
