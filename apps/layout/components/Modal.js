import React, { Fragment } from 'react'

export default function Modal({children, isOpen, onClose}) {
  return (
    <Fragment>
      {isOpen ? (
        <Fragment>
          <div className="modal-bg" onClick={() => onClose()}></div>
          <div className="modal-window">
            {children}
          </div>
        </Fragment>
      ) : ""}
    </Fragment>
  )
}