import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "slotId", "bookAppointment" ]
    setParamForBookAppointment(){
        const slot_id = this.slotIdTargets.filter((slotEl) => slotEl.classList.contains('active'))[0].value
        console.log(slot_id)
        this.bookAppointmentTarget.href = `/appointments/add_details?slot_id=${slot_id}`
    }
}
