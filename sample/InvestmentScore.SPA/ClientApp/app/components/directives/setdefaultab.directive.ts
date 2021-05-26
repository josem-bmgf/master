import { Directive, ElementRef, HostListener, Input } from '@angular/core';


@Directive({
    selector: '[setDefaultTab]'
})

export class SetDefaultTabDirective {
    private _defaultTabId = 'scoringTab';

    private htmlElement: HTMLElement;

    constructor(elementRef: ElementRef) { this.htmlElement = elementRef.nativeElement; }

    //@Input() set defaultTab(iDefaultTabId: string) {
    //    this._defaultTabId = iDefaultTabId || this._defaultTabId;
    //}

    @Input('setDefaultTab') tabId: string;

    @HostListener('click') onClick() {
        this.setDefaultTab(this.tabId || this._defaultTabId);
    }

    private setDefaultTab(tabId: string) {
        this.htmlElement = document.getElementById(tabId);
        if (typeof this.htmlElement !== "undefined" && this.htmlElement !== null) {
            this.htmlElement.click();
        }
    }
}