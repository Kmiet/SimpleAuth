import React from 'react'

export default function View({ children, width }) {

  return (
    <div class="app-view">
      <div></div>
      <div style={{ width: width + 'px', minHeight: 'calc(100vh - var(--navbar-height))', margin: '0px auto' }}>
        {children}
      </div>
    </div>
  )
}