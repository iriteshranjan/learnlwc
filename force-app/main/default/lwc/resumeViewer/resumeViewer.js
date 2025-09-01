import { LightningElement } from 'lwc';
import resumeFile from '@salesforce/resourceUrl/MyResume'; // Upload PDF to Static Resources

export default class ResumeViewer extends LightningElement {
    pdfUrl = resumeFile;
}
