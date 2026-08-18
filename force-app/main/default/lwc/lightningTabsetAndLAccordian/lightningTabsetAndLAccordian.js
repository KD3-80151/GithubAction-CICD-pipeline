import { LightningElement } from 'lwc';

export default class LightningTabsetAndLAccordian extends LightningElement {
    tabs = [
        {
            label: 'Company Info',
            sections: [
                {
                    id: 'mission',
                    title: 'Our Mission',
                    content: 'We strive to revolutionize the digital experience with cutting-edge cloud solutions.'
                },
                {
                    id: 'vision',
                    title: 'Our Vision',
                    content: 'To become the leading provider of intelligent enterprise platforms worldwide.'
                }
            ]
        },
        {
            label: 'Team Members',
            sections: [
                {
                    id: 'ceo',
                    title: 'CEO - Aisha Khan',
                    content: 'Aisha brings 15+ years of SaaS leadership, innovation, and execution to the company.'
                },
                {
                    id: 'cto',
                    title: 'CTO - Rahul Mehta',
                    content: 'Rahul is a tech visionary focusing on scalable architecture and AI-powered platforms.'
                }
            ]
        },
        {
            label: 'Services',
            sections: [
                {
                    id: 'consulting',
                    title: 'Cloud Consulting',
                    content: 'We provide tailored Salesforce consulting services across Sales, Service, and Experience Clouds.'
                },
                {
                    id: 'integration',
                    title: 'Integrations',
                    content: 'Expert in connecting Salesforce with third-party platforms like WhatsApp, SAP, and more.'
                }
            ]
        }
    ];
}