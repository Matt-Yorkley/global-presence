// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { registerControllers } from 'stimulus-vite-helpers'
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import controller from '../controllers/application_controller'
import CableReady from 'cable_ready'

const application = Application.start()
const controllers = import.meta.globEager('./**/*_controller.js')
registerControllers(application, controllers)
application.consumer = consumer
StimulusReflex.initialize(application, { controller, isolate: true })
StimulusReflex.debug = import.meta.env.DEV
CableReady.initialize({ consumer })
