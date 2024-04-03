import {LightningElement, api} from 'lwc';

export default class SpinnerComponent extends LightningElement {
    @api spinnerText = '';
    @api spinnerSize = "medium";
    @api spinnerVariant = "brand";
}