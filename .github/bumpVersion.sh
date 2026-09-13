#!/bin/bash

NEWVERCODE=$(($(cat app/build.gradle.kts | grep versionCode | tr -s ' ' | cut -d " " -f 4 | tr -d '\r')+1))
NEWVERNAME=${GITHUB_REF_NAME/v/}

echo 'VTag<<EOF' >> $GITHUB_ENV
echo $NEWVERNAME >> $GITHUB_ENV
echo 'EOF' >> $GITHUB_ENV

echo 'VName<<EOF' >> $GITHUB_ENV
echo 'Beta '$NEWVERCODE >> $GITHUB_ENV
echo 'EOF' >> $GITHUB_ENV

# bump versions
sed -i 's/versionCode.*/versionCode = '$NEWVERCODE'/' app/build.gradle.kts
sed -i 's/versionName =.*/versionName = "'$NEWVERNAME'"/' app/build.gradle.kts

# app changelog
echo "**$NEWVERNAME**  " > newChangeLog.md
cat .github/workflowsFiles/FutureChanageLog.md >> newChangeLog.md
echo "  " >> newChangeLog.md
cat StableChangelog.md >> newChangeLog.md
mv  newChangeLog.md StableChangelog.md

# release notes
echo "**Changelog:**  " > releaseNotes.md
cat .github/workflowsFiles/FutureChanageLog.md >> releaseNotes.md

# changelog message
echo "*$NEWVERNAME* released !" > telegram.msg
echo "  " >> telegram.msg
echo "*Changelog:*  " >> telegram.msg
cat .github/workflowsFiles/FutureChanageLog.md >> telegram.msg
echo 'TMessage<<EOF' >> $GITHUB_ENV
cat telegram.msg >> $GITHUB_ENV
echo >> $GITHUB_ENV
echo 'EOF' >> $GITHUB_ENV