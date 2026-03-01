// Check if matches collection has scraped data
const fs = require('fs');
const path = require('path');
const os = require('os');

async function main() {
    const config = JSON.parse(fs.readFileSync(path.join(os.homedir(), '.config/configstore/firebase-tools.json'), 'utf-8'));
    const token = config?.tokens?.access_token;
    const base = 'https://firestore.googleapis.com/v1/projects/futbol-ai-app/databases/(default)/documents';

    // Check matches collection
    const matchesResp = await fetch(`${base}/matches?pageSize=5`, { headers: { 'Authorization': `Bearer ${token}` } });
    const matchesData = await matchesResp.json();
    console.log('=== MATCHES collection ===');
    console.log(`Document count: ${matchesData.documents?.length || 0}`);
    if (matchesData.documents?.length) {
        for (const doc of matchesData.documents) {
            const id = doc.name.split('/').pop();
            const fields = doc.fields || {};
            const home = fields.homeTeam?.mapValue?.fields?.name?.stringValue ||
                fields.meta?.mapValue?.fields?.homeTeam?.stringValue || 'N/A';
            const away = fields.awayTeam?.mapValue?.fields?.name?.stringValue ||
                fields.meta?.mapValue?.fields?.awayTeam?.stringValue || 'N/A';
            const league = fields.league?.stringValue ||
                fields.meta?.mapValue?.fields?.league?.stringValue || 'N/A';
            const hasFbref = !!fields.fbref;
            const hasSofascore = !!fields.sofascore;
            const hasUnderstat = !!fields.understat;
            const completeness = fields.dataCompleteness?.doubleValue ?? fields.dataCompleteness?.integerValue ?? 'N/A';
            const sources = fields.sources?.arrayValue?.values?.map(v => v.stringValue).join(', ') || 'none';
            console.log(`  ${id}: ${home} vs ${away} | ${league} | fbref:${hasFbref} sofa:${hasSofascore} under:${hasUnderstat} | completeness:${completeness} | sources:${sources}`);
        }
    }

    // Check teams collection
    const teamsResp = await fetch(`${base}/teams?pageSize=5`, { headers: { 'Authorization': `Bearer ${token}` } });
    const teamsData = await teamsResp.json();
    console.log(`\n=== TEAMS collection ===`);
    console.log(`Document count: ${teamsData.documents?.length || 0}`);
    if (teamsData.documents?.length) {
        for (const doc of teamsData.documents.slice(0, 5)) {
            const id = doc.name.split('/').pop();
            console.log(`  ${id}`);
        }
    }

    // Check scrapeHistory
    const histResp = await fetch(`${base}/scrapeHistory?pageSize=5`, { headers: { 'Authorization': `Bearer ${token}` } });
    const histData = await histResp.json();
    console.log(`\n=== SCRAPE HISTORY ===`);
    console.log(`Document count: ${histData.documents?.length || 0}`);

    // Check sportoto_matches count
    const stResp = await fetch(`${base}/sportoto_matches?pageSize=3`, { headers: { 'Authorization': `Bearer ${token}` } });
    const stData = await stResp.json();
    console.log(`\n=== SPORTOTO_MATCHES ===`);
    console.log(`Document count: ${stData.documents?.length || 0}`);
    if (stData.documents?.length) {
        for (const doc of stData.documents.slice(0, 3)) {
            const id = doc.name.split('/').pop();
            const home = doc.fields?.homeTeam?.mapValue?.fields?.name?.stringValue || 'N/A';
            const away = doc.fields?.awayTeam?.mapValue?.fields?.name?.stringValue || 'N/A';
            console.log(`  ${id}: ${home} vs ${away}`);
        }
    }
}
main().catch(console.error);
