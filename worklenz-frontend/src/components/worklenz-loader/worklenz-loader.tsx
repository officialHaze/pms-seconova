import { memo } from 'react';

import './worklenz-loader.css';

// Served from public/assets/icons, so it is cached after the first load.
const LOGO_SRC = '/assets/icons/icon-128x128.png';

export const WorklenzLogoLoader = memo(() => (
  <div role="status" className="secteams-loader">
    <span className="secteams-loader__ring" aria-hidden="true" />
    <img
      className="secteams-loader__logo"
      src={LOGO_SRC}
      alt=""
      width={42}
      height={42}
      draggable={false}
      decoding="async"
    />
    <span className="secteams-loader__sr">Loading...</span>
  </div>
));

WorklenzLogoLoader.displayName = 'SecteamsLoader';
