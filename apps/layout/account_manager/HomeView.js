import React, { Fragment, useState } from 'react'

import Button from '../components/Button'
import Modal from '../components/Modal'
import View from '../components/View'
import ClientCard from './ClientCard'

export default function HomeView({ clients }) {

  const [modalOpen, setOpen] = useState(false)

  return (
    <View width="1280">
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
        {clients.length > 0 ? (
          <Fragment>
            <div style={{ margin: '20px 0px' }}>
              <span style={{ float: 'left', color: 'var(--secondary_10_light)', margin: '10px 0px' }}>{"Results " + clients.length}</span>
              <Button id="new-app-button" text="Add App" onClick={() => setOpen(true)} />
            </div>
            {clients.map(client => {
              return <ClientCard 
                clientId={client.id} 
                clientDesc={client.desc} 
                clientName={client.name} 
                logo={client.logo}
                />
            })}
          </Fragment>
        ) : (
          <Fragment>
              <p id="call-header-no-apps" style={{ color: 'white' }}>You have no apps registered</p>
              <Button id="call-link-first-app" text="Add new App" onClick={() => setOpen(true)} />
          </Fragment>
        )
        }
      </div>
      <Modal isOpen={modalOpen} onClose={() => setOpen(false)}>
        <div style={{ display: 'flex', width: '100%', height: '100%', flexDirection: 'column' }}>
          <p>hi</p>
          <p>input</p>
        </div>
      </Modal>
    </View>
  )
}