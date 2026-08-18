import { LightningElement, track } from 'lwc';
import getStats from '@salesforce/apex/LeadOpportunityStatsController.getStats';

export default class LeadOppDashboard extends LightningElement {
  @track loading = true;
  @track totals = { totalLeads: 0, totalOpps: 0, totalAll: 0 };
  @track leadBucketsAll = [];
  @track oppBucketsAll = [];
  @track error;

  leadDisplay = [
    { label: 'Open - Not Contacted', from: ['Open - Not Contacted'] },
    { label: 'Working - Contacted', from: ['Working - Contacted'] },
    { label: 'Demo', from: ['Demo'] },
    { label: 'Follow Up', from: ['Follow Up'] },
    { label: 'New/Active', from: ['New', 'Active'] },
    { label: 'Closed - Converted', from: ['Closed - Converted'] },
  ];

  oppDisplay = [
    { label: 'Prospecting', from: ['Prospecting'] },
    { label: 'Qualification', from: ['Qualification'] },
    { label: 'Needs Analysis', from: ['Needs Analysis'] },
    { label: 'Proposal/Price Quote', from: ['Proposal/Price Quote'] },
    { label: 'Negotiation/Review', from: ['Negotiation/Review'] },
    { label: 'Closed Won/Closed Lost', from: ['Closed Won', 'Closed Lost'] }
  ];

  connectedCallback() { debugger; this.loadData(); }

  async loadData() {
    debugger;
    this.loading = true;
    this.error = undefined;
    try {
      const data = await getStats();
      console.log('data:', data);
      this.totals = { totalLeads: data?.totalLeads || 0, totalOpps:  data?.totalOpps  || 0, totalAll: data?.totalAll ?? ((data?.totalLeads || 0) + (data?.totalOpps || 0))
      };
      this.leadBucketsAll = data?.leadBuckets || [];
      this.oppBucketsAll  = data?.oppBuckets  || [];
    } catch (e) {
      this.error = e?.body?.message || e?.message || 'Failed to load stats';
    } finally {
      this.loading = false;
    }
  }

  toMap(list) {
    debugger;
    console.log('list:', list);
    const m = new Map();
    (list || []).forEach(b => m.set(b.label, b.count || 0));
    return m;
  }

   sumFrom(map, labels) {
    debugger;
    return (labels || []).reduce((acc, k) => acc + (map.get(k) || 0), 0);
  }

  
  pct(numerator, denominator) {
    debugger;
    if (!denominator || denominator <= 0) return '—';
    const val = (numerator / denominator) * 100;
    console.log('valueeeeee::>>' + val);
    return `${val.toFixed(2)}%`;
  }

 buildRows(spec, sourceMap, totalAll, firstPrevBaselineCount) {
    debugger;
    let rows = [];
    let prev = firstPrevBaselineCount;
    console.log('firstPrevBaselineCount::>>' + firstPrevBaselineCount);

    for (const item of spec) {
      const count = this.sumFrom(sourceMap, item.from);
      const conversion = this.pct(count, prev);
      const shareOfTotal = this.pct(count, totalAll);
      console.log('count::>>' + count);
      console.log('conversion::>>' + conversion);
      console.log('shareOfTotal::>>' + shareOfTotal);

      rows.push({label: item.label, count, conversion, cummulativeConversion: shareOfTotal });

      prev = count;
    }
    return rows;
  }

  get leadRows() {
    debugger;
    const leadMap = this.toMap(this.leadBucketsAll);
    const firstPrev = this.totals.totalAll || 0; 
    return this.buildRows(this.leadDisplay, leadMap, this.totals.totalAll || 0, firstPrev);
  }

  get oppRows() {
    debugger;
    const leadMap = this.toMap(this.leadBucketsAll);
    const oppMap  = this.toMap(this.oppBucketsAll);

    const leadHandOffCount =
      this.sumFrom(leadMap, ['Converted']);

    const firstPrev = leadHandOffCount || 0;
    console.log('leadHandOffCount::>>' + leadHandOffCount);
    return this.buildRows(this.oppDisplay, oppMap, this.totals.totalAll || 0, firstPrev);
  }

  get totalLeadsFmt() { return this.formatNum(this.totals.totalLeads); }
  get totalOppsFmt()  { return this.formatNum(this.totals.totalOpps); }
  get totalAllFmt()   { return this.formatNum(this.totals.totalAll); }

  formatNum(n) { debugger; try { return (n ?? 0).toLocaleString(); } catch { return `${n ?? 0}`; } }
}