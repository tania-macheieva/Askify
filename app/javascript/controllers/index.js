// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import ToastController from "./toast_controller"

eagerLoadControllersFrom("controllers", application)

const application = Application.start()
application.register("toast", ToastController)