import { Injectable }    from '@angular/core';
import { Http, Headers } from '@angular/http';

import 'rxjs/add/operator/toPromise';

import { LicenseStatus } from './license-status'

declare var Config: any; //  this comes from the autogenerated config.js file

@Injectable()
export class LsdService {
    defaultHttpHeaders = new Headers(
        {'Content-Type': 'application/json'});
    baseUrl: string = Config.lsd.url;

    constructor (private http: Http) {
    }

    get(id: string): Promise<LicenseStatus> {
        let url = this.baseUrl + "/licenses/" + id + "/status";
        return this.http
            .get(
                url,
                { headers: this.defaultHttpHeaders })
            .toPromise()
            .then(function (response) {
                if (response.ok) {
                    let jsonObj = response.json();
                    let licenseStatus = jsonObj as LicenseStatus;
                    return licenseStatus;
                } else {
                    throw 'Error retrieving license ' + response.text();
                }
            })
            .catch(this.handleError);
    }

    protected handleError(error: any): Promise<any> {
        console.error('An error occurred', error);
        return Promise.reject(error.message || error);
    }
}