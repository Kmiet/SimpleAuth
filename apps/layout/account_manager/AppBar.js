import React, { Fragment, useState } from 'react'
import { Link, Route, Switch, Redirect } from 'react-router-dom'
import axios from 'axios'

import Button from '../components/Button'
import Icon from '../components/Icon'

export default function AppBar({ user, onLogout, currentClient }) {

  const [showDropdown, setShown] = useState(false)
  const [showDrawer, setOpen] = useState(false)

  return (
    <Fragment>
      <div id="app-bar">
        <div>
          <nav id="app-bar-nav">
            <div className="app-bar-nav-link" onClick={() => onLogout()}>
              <Icon className="app-bar-nav-icon" name="power_settings_new" />
              <span className="app-bar-nav-label">Logout</span>
            </div>
            <Link to="/settings" className="app-bar-nav-link">
              <Icon className="app-bar-nav-icon" name="settings" />
              <span className="app-bar-nav-label">Settings</span>
            </Link>
            <Link to="/profile" className="app-bar-nav-link">
              <Icon className="app-bar-nav-icon" name="person" />
              <span className="app-bar-nav-label">My Profile</span>
            </Link>
            <Link to="/" className="app-bar-nav-link">
              <Icon className="app-bar-nav-icon" name="apps" />
              <span className="app-bar-nav-label">My Apps</span>
            </Link>
          </nav>
          <div style={{ flex: 1 }}></div>
          {currentClient !== undefined ? (
              <div>
                {currentClient.logoURI !== undefined ? (
                  <img className="app-bar-client-logo" src={currentClient.logoURI} /> 
                  ) : ""
                }
                <span className="app-bar-client-name">{currentClient.name}</span>
              </div>
            ) : ""
          }
          <div style={{ flex: 1 }}></div>
          <Fragment>
            <span>
              {user.username !== undefined ? user.username : (user.name !== undefined ? user.name : user.email)}
            </span>
            {user.avatarURI !== undefined ? (
                <img id="app-bar-user-avatar" src={user.avatarURI} onClick={() => setShown(!showDropdown)} />
              ) : (
                <Icon id="app-bar-user-avatar" name="account_box" onClick={() => setShown(!showDropdown)} />
              )}
          </Fragment>
          <Button id="hamburger" onClick={() => setOpen (!showDrawer)} text={<Icon name="menu" />} />
        </div>
      </div>
      <div id="drawer-menu">
        <Button onClick={() => setOpen(!showDrawer)} text="close" />
      </div>
    </Fragment>
  )
}