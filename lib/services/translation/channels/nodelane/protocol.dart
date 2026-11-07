/// NodeLane's authenticated, per-image translation protocol. Protocol fields
/// stay inside this adapter; readers consume only the public channel contract.
const nodeLaneTranslationProtocol = 'overlay-v1';
const nodeLaneTranslationProtocolHeader = 'X-Translation-Protocol';

const nodeLaneNonRetryableErrors = {
  'CLASSIC_ANALYSIS_TOO_LARGE',
  'CLASSIC_REGION_LIMIT_EXCEEDED',
  'CLASSIC_TEXT_LIMIT_EXCEEDED',
};
