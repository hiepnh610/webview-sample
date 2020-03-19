import { Component, OnInit, NgZone } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  public fullName = '';

  profileForm = new FormGroup({
    fullName: new FormControl('')
  });

  constructor(private ngZone: NgZone) {}

  onSubmit() {
    const frm = this.profileForm.value;
    const fullNameVal = frm.fullName;

    if (fullNameVal) {
      if ((window as any).webkit) {
        return (window as any).webkit.messageHandlers.sampleFunction.postMessage(fullNameVal);
      }
    }
  }

  listenerFromNative(payload: string) {
    this.ngZone.run(() => {
      this.fullName = payload;
    });
  }

  ngOnInit() {
    (window as any).webview = this;
  }
}
